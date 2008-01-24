Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYAXUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYAXUxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYAXUxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:53:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48181 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYAXUxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:53:22 -0500
Date: Thu, 24 Jan 2008 21:53:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kconfig: remove "enable"
Message-ID: <20080124205326.GA3689@uranus.ravnborg.org>
References: <20080122235439.GJ26556@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122235439.GJ26556@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 01:54:39AM +0200, Adrian Bunk wrote:
> Kconfig had a synonym "enable" for "select" that was neither documented 
> nor used.

Fixed up to apply to latest kbuild.git and applied.

	Sam
