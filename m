Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXGUFNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXGUFNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXGUFNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:13:33 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2079 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXGUFNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:13:32 -0400
Date: Sat, 21 Jul 2007 07:05:50 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: where is the code for read system call?
Message-ID: <20070721050544.GA27684@vanheusden.com>
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun Jul 22 00:42:24 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My application reads from socket. I need to change the behavior of read
> system call for an experiment. Can someone point me to code?

Wouldn't it be easier to create a preload-library-wrapper around glibc?


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
