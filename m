Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZIQAMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZIQAMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZIQAMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:12:32 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:41862 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZIQAMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qdWBC+YUdC+7K2nkUgjWaPGe9rGpIQ9ehbld6tZEiCtJI9k8KQhYEkzLBPtjDvpPYn
         At7Fe7lK7c30Qz4teBvpwJVbHeP5fST/42kwW2kOOnQcJfaStBzk9dX9Mt+IlI+vseHF
         K7rb+n38z3DDLl3RPhlGypVj6w7pWion7w83s=
MIME-Version: 1.0
In-Reply-To: <200909161619.33461.elendil@planet.nl>
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
	 <200909142301.17936.elendil@planet.nl>
	 <200909161619.33461.elendil@planet.nl>
Date: Thu, 17 Sep 2009 08:12:34 +0800
Message-ID: <31cb94fa0909161712m3343812cw349b4a7233bda126@mail.gmail.com>
Subject: Re: PATCH: ARCH in builddeb
From: Wei Chong Tan <weichong78@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, it is as I feared. Your patch results in an "arm" package when I do a
> cross-build for "armel" (for which I must of course set ARCH to "arm" as
> armel is not a valid Linux architecture).
> A possible solution could be to check that CROSS_COMPILE is *not* set, but
> I'm not sure if that would be the correct solution. Input from others on
> this would be welcome.

Thanks Frans for the help,
I will try to check CROSS_COMPILE and see in addition to other alternatives.

Regards,
Wei Chong.
