Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYBGKOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYBGKOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYBGKOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:14:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:1460 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYBGKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C5RaYwEVavVxK8Oj4WVtGlk0y11tzXjmMZs32h0vAJALGa7TPXWhRK03Slm9C6aUioz5HTUzrULILe5x2O69etQ2ta9gpsGlEyHKpwnpNF3X2gxjfed4KslRYdwyoGeOyvMtRm8MeZyiYcGorqBNlUlNHEjfWOlgdASmWkF7svk=
Message-ID: <b6a2187b0802070214u5a86e5a7p7c06900cc9bd3a9d@mail.gmail.com>
Date: Thu, 7 Feb 2008 18:14:22 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: serge@hallyn.com
Subject: Re: where is the capset kernel module?
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morgan" <morgan@kernel.org>
In-Reply-To: <20080207032331.GA25762@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
	 <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com>
	 <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr>
	 <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
	 <20080207032331.GA25762@vino.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 11:23 AM,  <serge@hallyn.com> wrote:

> Odd, I thought the help text was originally far more helpful, including
> a url.  The message isn't telling you you need a kernel module, but that
> you are using an old libcap.  It isn't a real problem right now if
> you're not using the SMACK LSM, but to get rid of the message upgrade
> your libcap from
> http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/libcap-2.05.tar.gz

That's very useful. I'll try it this weekend.

Thanks for your help!

Jeff.
