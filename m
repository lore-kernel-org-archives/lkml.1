Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZEDQ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZEDQ01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZEDQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:26:17 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:60636 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZEDQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:26:17 -0400
Date: Mon, 4 May 2009 12:15:20 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alloc_vmap_area: fix memory leak
In-Reply-To: <20090504163731.3675ea87@rwuerthntp>
Message-ID: <alpine.DEB.1.10.0905041214160.15574@qirst.com>
References: <20090504163731.3675ea87@rwuerthntp>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
