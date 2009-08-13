Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZHNMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZHNMUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZHNMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:20:08 -0400
Received: from main.gmane.org ([80.91.229.2]:40796 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZHNMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:20:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH] Jtag bitbang driver proposal
Date: Thu, 13 Aug 2009 17:56:37 +0200
Organization: Church of Emacs - Missionary division
Message-ID: <m2d46zlnbe.fsf@ohwell.denx.de>
References: <8447d6730908130317j2ac1ae07s1ecbd5bdd835f8b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4ff062ea.dip.t-dialin.net
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
Cancel-Lock: sha1:x6oYZaRMMoZZVXSFQIZsZ+L2Ass=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> Maybe this is not the right place / list to propose this, I searched
> for misc drivers in maintainer list. Could you otherwise address me ?
> Grazie Alessandro.
>
> Generic bitbang driver to drive jtag chains

Did you look at the UrJTAG project[1]?  We recently used that on top of a
pretty standard GPIO driver.  If needed, I can dig up details.

Cheers
  Detlev

[1] http://urjtag.sourceforge.net/

--
DENX Software Engineering GmbH,      MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich,  Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-40 Fax: (+49)-8142-66989-80 Email: dzu@denx.de

