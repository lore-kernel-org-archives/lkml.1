Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856Ab0A2Knq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0A2Knq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363Ab0A2Knp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:43:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41271 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0A2Kno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:43:44 -0500
Date: Fri, 29 Jan 2010 12:40:51 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Roel Kluin <roel.kluin@gmail.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] musb: don't dereference NULL tusb_dma in
 dma_controller_destroy()
Message-ID: <20100129104051.GA9930@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <4B48EDC8.1000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4B48EDC8.1000006@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jan 2010 10:42:57.0841 (UTC) FILETIME=[D22E6210:01CAA0CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 09:57:44PM +0100, ext Roel Kluin wrote:
>Test whether tusb_dma is not NULL before dereferencing
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Felipe Balbi <felipe.balbi@nokia.com>

-- 
balbi
