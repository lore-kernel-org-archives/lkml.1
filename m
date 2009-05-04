Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbZEDSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbZEDSAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbZEDR74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:59:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779AbZEDR7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:59:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow_signal: kill the bogus ->mm check, add a note about
	CLONE_SIGHAND
In-Reply-To: Oleg Nesterov's message of  Monday, 4 May 2009 00:17:37 +0200 <20090503221737.GA26523@redhat.com>
References: <20090503221737.GA26523@redhat.com>
X-Shopping-List: (1) Embryonic turkeys
   (2) Revised fashions
   (3) Incredulous Johnny Carson lookalikes
   (4) Samsonite Repressed rendezvous honey
Message-Id: <20090504175909.5BDF9FC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 10:59:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
