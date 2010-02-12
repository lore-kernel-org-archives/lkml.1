Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0BLU15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:27:57 -0500
Received: from smtp.witbe.net ([81.88.96.48]:43449 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab0BLU14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:27:56 -0500
Date: Fri, 12 Feb 2010 21:26:32 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: Linux 2.6.33-rc8
Message-ID: <20100212212632.53cbdc46@tux.DEF.witbe.net>
In-Reply-To: <4B75B5D8.5080602@mandriva.org>
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>
	<4B75B5D8.5080602@mandriva.org>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 12 Feb 2010 22:11:04 +0200
Thomas Backlund <tmb@mandriva.org> wrote:

> 12.02.2010 21:49, Linus Torvalds skrev:
> >
> > I think this is going to be the last -rc of the series, so please do
> > test it out. A number of regressions should be fixed, and while the
> > regression list doesn't make me _happy_, we didn't have the kind of
> > nasty things that went on before -rc7 and made me worried.
> >
> Has the mirroring broken down ?

-ECANTDOWNLOAD

+1 from France using ftp.kernel.org :
ftp> dir linux-2.6.33-rc7*
227 Entering Passive Mode (199,6,1,164,158,19).
150 Here comes the directory listing.
-rw-rw-r--    1 536      536      66191954 Feb 06 22:27 linux-2.6.33-rc7.tar.bz2
-rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.bz2.sign
-rw-rw-r--    1 536      536      84523618 Feb 06 22:27 linux-2.6.33-rc7.tar.gz
-rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.gz.sign
-rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.sign
226 Directory send OK.
ftp> dir linux-2.6.33-rc8*
227 Entering Passive Mode (199,6,1,164,203,16).
150 Here comes the directory listing.
226 Directory send OK.
ftp> quit

and www.kernel.org doesn't contain reference to -rc8 yet.

Paul



