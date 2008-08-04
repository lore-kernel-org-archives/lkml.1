Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYHDIdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYHDIdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYHDIdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:33:46 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55024 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752090AbYHDIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:33:45 -0400
Date: Mon, 4 Aug 2008 10:33:44 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] embedded: fix vc_translate operator precedence
In-Reply-To: <1217838685.3454.564.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0808041033270.31424@vixen.sonytel.be>
References: <48937AAE.5070407@am.sony.com> <Pine.LNX.4.64.0808041028230.31424@vixen.sonytel.be>
 <1217838685.3454.564.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1414564800-1217838824=:31424"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1414564800-1217838824=:31424
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 4 Aug 2008, David Woodhouse wrote:
> On Mon, 2008-08-04 at 10:29 +0200, Geert Uytterhoeven wrote:
> > The above paragraph is not part of the patch description and should
> > not end up in the git history, so it should be below the first `---'
> > and above the diffstat, i.e.
> 
> Since it reports successful testing, I figured I might as well keep it.

... unlike all other patches you take? ;-)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1414564800-1217838824=:31424--
