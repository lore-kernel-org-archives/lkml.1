Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXHRIVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXHRIVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 04:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbXHRIVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 04:21:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41364 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXHRIVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 04:21:35 -0400
Date: Sat, 18 Aug 2007 10:21:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Satyam Sharma <satyam@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <1187394022.7007.133.camel@chaos>
Message-ID: <Pine.LNX.4.64.0708181020370.5186@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com>  <1187132149.2618.2.camel@laptopd505.fenrus.org>
  <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in> 
 <20070817112253.e6a7cb33.akpm@linux-foundation.org> 
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com> 
 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
 <1187394022.7007.133.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18 2007 01:40, Thomas Gleixner wrote:
>
>Do we really ? 
>
>If yes, who invented this 1980s reminiscence, where you got valid
>pointers for malloc(0) ?
>
>This is completely stupid. You do not go into a bar and order an empty
>glass, just because you might eventually become thirsty later.

Actually, this is how all-you-can-drink offers work. ;-)


	Jan
-- 
