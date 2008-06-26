Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYFZHLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYFZHLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZHLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:11:05 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:39702 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYFZHLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:11:04 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org
Subject: Compilation warnings: 2.6.24.8->2.6.25.9
Date: Thu, 26 Jun 2008 10:12:01 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261012.01046.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

While upgrading from 2.6.24.8 to 2.6.25.9 I got:

fs/nfs/callback_xdr.c: In function 'nfs4_callback_compound':
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.taglen' may be used uninitialized in this function
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.tag' may be used uninitialized in this function
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.nops' may be used uninitialized in this function

Could it cause problems?

Regards

Marin Mitov

