Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYLHL4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYLHL4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYLHLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:51:19 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47098 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbYLHLvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:51:17 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
Date: Mon, 8 Dec 2008 12:51:14 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200812021114.59050.borntraeger@de.ibm.com>
In-Reply-To: <200812021114.59050.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081251.14648.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Dezember 2008 schrieb Christian Borntraeger:
> Hello Avi,
> 
> here is the latest respin of my fixes for the kvm module unload problem:
> 
> [PATCH 1/2] anon_inodes: use fops->owner for module refcount
> [PATCH 2/2] kvm: set owner of cpu and vm file operations

In the meantime patch 2 has a offset against the latest git. Should I resend
the patch or will you apply it anyway?

Christian
