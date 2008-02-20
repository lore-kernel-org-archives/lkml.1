Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbYBTPiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbYBTPiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbYBTPek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:34:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbYBTPej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:34:39 -0500
Date: Wed, 20 Feb 2008 16:34:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: complete segment descriptor unification
Message-ID: <20080220153425.GA23153@elte.hu>
References: <1203521180-21489-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203521180-21489-1-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Remove the final line in asm-x86/desc_64.h

thanks, applied :-)

	Ingo
