Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYJZReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYJZReg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbYJZReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:34:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:48265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbYJZReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:34:22 -0400
Date: Sun, 26 Oct 2008 10:34:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: r8169 MAC addresses broken
Message-ID: <20081026103439.7a60005a@infradead.org>
In-Reply-To: <4904A7C5.7090801@gmail.com>
References: <490380C8.6070003@simon.arlott.org.uk>
	<4903947A.3060206@gmail.com>
	<20081025223443.GA30913@electric-eye.fr.zoreil.com>
	<4904A7C5.7090801@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 18:24:21 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 10/26/2008 12:34 AM, Francois Romieu wrote:
> > It may go away if one comments out rtl_init_mac_address in
> > rtl8169_init_one
> 
> Hmm, no. How can one restore eeprom contents without making a brick
> from the notebook? I seem to have all zeroes in the eeprom mac
> address area. --

same here...  :(

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
