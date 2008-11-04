Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYKDTMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYKDTMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYKDTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:12:44 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:54060 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYKDTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:12:43 -0500
Date: Tue, 4 Nov 2008 17:14:14 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: __bprm_mm_init(): remove uneeded goto
Message-ID: <20081104171414.6c1a8b52@doriath.conectiva>
In-Reply-To: <20081104105707.39dc5e30.akpm@linux-foundation.org>
References: <20081104140314.1b196764@doriath.conectiva>
	<20081104105707.39dc5e30.akpm@linux-foundation.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Nov 2008 10:57:07 -0800
Andrew Morton <akpm@linux-foundation.org> escreveu:

| The above code now uses the most common pattern for a kernel
| function.  One we've learned from hard experience!

 Wow, I have no words to thank you enough for this full explanation!

-- 
Luiz Fernando N. Capitulino
