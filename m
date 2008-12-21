Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYLUVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYLUVCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYLUVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:01:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:62662 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYLUVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ocyh2JrFGpYRumyXxSl9XKQPGWjORalidE6u+gy001Q5WjDH7ahU+V94kmUTKwJbkX
         Ka1Hi8hN6MriLaHtPTyF+vfEWAAE2lY4/hiQrHn58rF7dfC+dLteNwc38944EJTjjaFS
         8R719QudbPxbpa0+m1dJIzStlGoQwXBnUQpN0=
Message-ID: <8bd0f97a0812211301p85df8eev30df76e2006c9704@mail.gmail.com>
Date: Sun, 21 Dec 2008 16:01:26 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 04/26] kbuild: introduce $(kecho) convenience echo
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "Mike Frysinger" <vapier@gentoo.org>
In-Reply-To: <1229783497-19550-4-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081220142518.GA19390@uranus.ravnborg.org>
	 <1229783497-19550-4-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 09:31, Sam Ravnborg wrote:
> So declare a new KECHO variable that only does 'echo' when we
> are in a suitable verbose build mode

maybe you want to change the caps on KECHO in the changelog since it
is no longer KECHO but kecho ?
-mike
