Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZJFSWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZJFSWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbZJFSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:22:39 -0400
Received: from khc.piap.pl ([195.187.100.11]:38680 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbZJFSWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:22:38 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain> <4ACAA450.6030405@gmail.com>
Date: Tue, 06 Oct 2009 20:22:00 +0200
In-Reply-To: <4ACAA450.6030405@gmail.com> (Robert Hancock's message of "Mon,
	05 Oct 2009 19:58:40 -0600")
Message-ID: <m34oqcxu0n.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> Presumably a SATA bus communication error. Are you sure the SATA
> connections and cable are good?

It seems so. At least they are ok with different hw, and different ones
give the same results.
-- 
Krzysztof Halasa
