Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZLZTne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZLZTne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZLZTnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:43:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35437 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZLZTnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V/sfO4FqnDw1aPDWSADreymYjqBc/PMmr21N2TOFKP5JA5Q1NCXer1jyXLzNGXJ1qb
         qyro74k1lyIgZLRrGajGOBOwZAs6163P8CkXSMdnlT+8QkUy0LppwqQ+gK8VmEBW17SV
         4dUMzz2DDYr4rGDexO5cLKljTJIl/mGny7NEk=
MIME-Version: 1.0
In-Reply-To: <20091226105821.52d36ba8@nehalam>
References: <20091226105821.52d36ba8@nehalam>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 26 Dec 2009 14:43:10 -0500
Message-ID: <8bd0f97a0912261143h48aaaaefw5a83e65120629e75@mail.gmail.com>
Subject: Re: [ANNOUNCE] iproute 2.6.32 released
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 13:58, Stephen Hemminger wrote:
> This version of iproute2 utilities includes the changes necessary to support all the features in
> 2.6.32, but should be backward compatible with older releases. Lots of bug fixes and little
> things, the main area of change is around the always problematic 'ip route flush' interface.
>
> The tar ball is available at:
>  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.31.tar.bz2

URL and git says 2.6.31, but subject says 2.6.32, so i'm guessing
subject is the typoe
-mike
