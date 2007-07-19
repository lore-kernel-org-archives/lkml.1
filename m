Return-Path: <linux-kernel-owner+w=401wt.eu-S940655AbXGSRV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940655AbXGSRV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940594AbXGSRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:21:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:36990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940525AbXGSRV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:21:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
Date: Thu, 19 Jul 2007 19:21:22 +0200
User-Agent: KMail/1.9.6
Cc: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095451.3578E14E04@wotan.suse.de> <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
In-Reply-To: <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191921.22909.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> do we need to put __initdata just before =?

AFAIK gcc __attribute__ syntax allows both. It certainly seems to compile.

-Andi
