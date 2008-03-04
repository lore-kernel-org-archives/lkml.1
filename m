Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbYCDHPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbYCDHPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYCDHP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:15:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756717AbYCDHP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:15:27 -0500
Date: Mon, 3 Mar 2008 23:15:23 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtml.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Slub Freeoffset check overflow (updated)
In-Reply-To: <20080304061721.GA27279@Krystal>
Message-ID: <Pine.LNX.4.64.0803032314520.9543@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
 <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
 <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com>
 <20080229033255.GA2200@Krystal> <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
 <20080229132848.GA10565@Krystal> <20080304061721.GA27279@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you rediff your work against the slab-mm branch of my VM tree on 
kernel.org?
