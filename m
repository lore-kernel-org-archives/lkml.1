Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZILCN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZILCN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 22:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZILCN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 22:13:26 -0400
Received: from fifo99.com ([67.223.236.141]:47307 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZILCN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 22:13:26 -0400
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard
 ATP867X controllers
From: Daniel Walker <dwalker@fifo99.com>
To: "Jung-Ik (John) Lee" <jilee@google.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
In-Reply-To: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 19:14:01 -0700
Message-Id: <1252721641.28368.34.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 19:06 -0700, Jung-Ik (John) Lee wrote:
> From: John(Jung-Ik) Lee <jilee@google.com>
> 
> This is a new pata driver for ARTOP 867X 64bit 4-channel UDMA133 ATA
> ctrls.
> Based on the Atp867 data sheet rev 1.2, Acard, and in part on early
> ide codes
> from Eric Uhrhane <ericu@google.com>.

This driver has numerous checkpatch errors .. Could you run this though
scripts/checkpatch.pl and correct anything it finds?

Daniel

