Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbYDAVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbYDAVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYDAVgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:36:37 -0400
Received: from ozlabs.org ([203.10.76.45]:39712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYDAVgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:36:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18418.43731.795438.795485@cargo.ozlabs.ibm.com>
Date: Wed, 2 Apr 2008 08:36:19 +1100
From: Paul Mackerras <paulus@samba.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linuxppc-dev@ozlabs.org, trivial@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] powerpc: replace `__attribute' by `__attribute__'
In-Reply-To: <47F27155.1000103@tiscali.nl>
References: <47F26FF6.8070300@tiscali.nl>
	<47F27155.1000103@tiscali.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin writes:

> replace `__attribute' by `__attribute__'

Why?  Your commit message doesn't give any motivation.

Paul.
