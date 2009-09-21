Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZIUDko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZIUDko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 23:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZIUDkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 23:40:42 -0400
Received: from fifo99.com ([67.223.236.141]:58739 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZIUDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 23:40:41 -0400
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
From: Daniel Walker <dwalker@fifo99.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 20:40:35 -0700
Message-Id: <1253504435.9654.221.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your patches all have numerous serious style problems.. There are far
too many to even give a summary here, and they are all different kinds
of problems..

You would need to fix all these issues before these patches could move
forward. Could you run scripts/checkpatch.pl on you patches and fix all
the issues that it reports?

Daniel

