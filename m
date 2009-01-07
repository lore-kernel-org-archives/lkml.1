Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbZAGW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbZAGW4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZAGW4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:56:32 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57802
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZAGW4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:56:32 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Spaces in filenames in gen_initramfs_list.sh/gen_init_cpio.c?
Date: Wed, 7 Jan 2009 16:56:18 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071656.18802.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What do I do if I have a space in a filename that I want to put into an 
initramfs?  (Or a space in the source argument of "file" entries or the 
redirect argument of "slink" entries?)

I don't see any kind of quoting or escape syntax, has anybody planned one or 
should I go write something myself?

Rob
