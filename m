Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506Ab0ATId3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0ATId3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976Ab0ATId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:33:28 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:38390 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0ATId1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ASq370H7YUgiXfVJQdYHLS1mw7XOoYFDkdY0lJTZ2kNV8G9oD1yaHRBXcYX9xTmgIf
         JlikvEcilFpYAknMpn4HYqFVkPMyQbGiC7cLgdk+HerAeIC3tlOQSIu0YJoMOvIO/45I
         +L0H6bHyZ4cLIqGL8k4N8O2cBvcrctmHMLpQY=
MIME-Version: 1.0
In-Reply-To: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
References: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
From: Michael Wookey <michaelwookey@gmail.com>
Date: Wed, 20 Jan 2010 19:33:07 +1100
Message-ID: <d2e97e801001200033s342b3e1cuba6d973c161f137d@mail.gmail.com>
Subject: Re: how do YOU hack the linux kernel ?
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/19 Ramagudi Naziir <naziirr@gmail.com>:
> Assuming you don't remember their exact name/location, you'd need to
> use something like 'find . -iname '*pattern*'. which is slow.

You could use git to find the files quickly...

  ~/src/linux-2.6 (master)$ git ls-files *eeepc*
  Documentation/ABI/testing/sysfs-platform-eeepc-laptop
  drivers/platform/x86/eeepc-laptop.c
