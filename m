Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYAJUvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYAJUvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAJUvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:51:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48220 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYAJUvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:51:00 -0500
Message-ID: <4786852D.8080905@garzik.org>
Date: Thu, 10 Jan 2008 15:50:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Trond.Myklebust@netapp.com
CC: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: major NFSv4 client regression (-rc7)
References: <20080110204119.GA714@havoc.gtf.org>
In-Reply-To: <20080110204119.GA714@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further data point:

Eventually the client degraded into a state when -any- file access on 
NFS-mounted volume "/g" would hang.


