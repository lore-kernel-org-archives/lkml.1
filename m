Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZG1TIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZG1TIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZG1TIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:08:04 -0400
Received: from smtp.witbe.net ([81.88.96.48]:40441 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZG1TIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:08:04 -0400
Date: Tue, 28 Jul 2009 21:08:03 +0200
From: Paul Rolland <rol@as2917.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire
 vblank..."
Message-ID: <20090728210803.19556ba7@tux.DEF.witbe.net>
In-Reply-To: <20090728092319.52ea57f1@jbarnes-g45>
References: <20090728091622.50e9933b@tux.DEF.witbe.net>
	<200907281244.13467.elendil@planet.nl>
	<20090728145359.252ff759@tux.DEF.witbe.net>
	<20090728092319.52ea57f1@jbarnes-g45>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Tue, 28 Jul 2009 09:23:19 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> It indicates a userland problem, and yes we shouldn't print that
> message.  I've also posted a patch to quiet it a few times, but Dave
> hasn't picked it up yet.  Feel free to send it straight to Linus with
> my Reviewed-by if you want.
> 

Thx, will do that tomorrow morning, after making it compliant with Linux
rules for patch submission ;)

Rgds,
Paul

