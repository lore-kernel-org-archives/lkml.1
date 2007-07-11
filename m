Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXGKKZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXGKKZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbXGKKZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:25:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48407 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597AbXGKKZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:25:05 -0400
Date: Wed, 11 Jul 2007 11:24:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ram Pai <linuxram@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and shared-subtree
Message-ID: <20070711102449.GA22185@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ram Pai <linuxram@us.ibm.com>,
	Al Viro <viro@ftp.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
References: <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com> <1182808816.2816.7.camel@ram.us.ibm.com> <20070630094446.GB22889@infradead.org> <468652E2.4050901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468652E2.4050901@zytor.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 08:56:02AM -0400, H. Peter Anvin wrote:
> Is that conjecture, or do you have evidence to that effect?  Most users 
> of this file are using it via the glibc interfaces, and there probably 
> aren't all that many users of it in the first place.

I have written parsers for personal projects that might not have been
happy to deal with additional fields myself for example..

