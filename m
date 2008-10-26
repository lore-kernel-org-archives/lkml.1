Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYJZKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYJZKO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYJZKOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:14:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41838 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYJZKOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:14:17 -0400
Subject: Re: [PATCH] ubifs: endian handling fixes and annotations
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224960775.5784.13.camel@brick>
References: <1224870777.5966.3.camel@brick>
	 <1224932256.4466.135.camel@sauron>  <1224960775.5784.13.camel@brick>
Content-Type: text/plain; charset=utf-8
Date: Sun, 26 Oct 2008 12:12:27 +0200
Message-Id: <1225015947.4466.142.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Oct 2008 10:13:39.0560 (UTC) FILETIME=[8424FE80:01C93753]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 11:52 -0700, Harvey Harrison wrote:
> Run sparse with -D__CHECK_ENDIAN__ to see these warnings.

Thanks. Pushed your patch to ubifs-2.6.git.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

