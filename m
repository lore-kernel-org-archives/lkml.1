Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZLFPMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZLFPMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 10:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbZLFPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 10:12:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35939 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZLFPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 10:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FihZf+yIKyBV5BAvCusjIEWvwbET5PkzyyqLYl0mQP4++KT8hC/8NYdehYLXzXdtNv
         IHNLlupXINaEF1Ts1XqpDOizCvRsaeeWYECyeifKEAlRsVYksRQlrzFyZOJuYSSuyZVH
         I8vvc0uioh/zjk3vUqXFr0YYnRs7amgouocO8=
MIME-Version: 1.0
In-Reply-To: <cone.1260110279.127989.3159.1000@onepiie>
References: <2a6e8c0d0912052133v3e112bdbx2c95b17437bdd182@mail.gmail.com> 
	<cone.1260110279.127989.3159.1000@onepiie>
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
Date: Sun, 6 Dec 2009 10:12:19 -0500
Message-ID: <2a6e8c0d0912060712n32fa2890r9055ddbac440366a@mail.gmail.com>
Subject: Re: acerhdf: BIOS product mismatch due to whitespace
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 6, 2009 at 09:37, Peter Feuerer <peter@piie.net> wrote:
>
> could you please be so kind and test:
> http://piie.net/files/acerhdf_kmod-0.5.22.tar.gz

Yep, that does the trick nicely. Thanks. Are you submitting that for .32-stable?

-- 
Ian Morgan
