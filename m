Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbYDNUXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbYDNUXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYDNUXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:23:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:4024 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYDNUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qxqqODlddhg4XQyZFHT/dVJ6V5xlTXAhwZTqecjqWLK+Os3teo5cb3Ld7f/WESC+QIfZTH/yP6w/3eL2Q6tixay5Fhao5Os0WDITrjkKy68NdlzJENuTdCULqfkrfXSCU+fxmw56/LrzgVEpLzWuTAdZCTJXumt2ryMsHcBxasU=
Date: Mon, 14 Apr 2008 16:23:14 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414162209.ZZRA012@mailhub.coreip.homeip.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com> <200804142006.51224.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804142006.51224.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:06:50PM +0100, Carlos Corbacho wrote:
> I agree wholeheartedly with Henrique here though - wireless drivers should 
> _not_ be using key press events as a reporting mechanism.
> 

Reporting mechanism for what exacly though? Depending on what you are
talking about we either agree or disagree here ;)

-- 
Dmitry
