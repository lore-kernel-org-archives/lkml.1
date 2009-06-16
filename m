Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbZFPKFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbZFPKFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZFPKEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:04:55 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:44663 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZFPKEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cffqm4VnETXA/Pc1dN4q3OZiOB9b5c9rpQCqAI6l6H//YW8I83HXOkdFW/zhhM9RxF
         Xk7b0H1xpeeQQdvvAZ3pgEkoRy9C3oOaBBqtsr3ZgzY/dvWrX8u/8mF6ebAP1poJfkYx
         dp+fyunbWjkNzuL1OHYTxyRq0WvGPOQWF0CBg=
MIME-Version: 1.0
In-Reply-To: <71cd59b00906160244t21bc0553tc8e209c70497687d@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
	 <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
	 <4A375914.5050800@tuffmail.co.uk>
	 <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
	 <71cd59b00906160244t21bc0553tc8e209c70497687d@mail.gmail.com>
Date: Tue, 16 Jun 2009 11:04:56 +0100
Message-ID: <15e53e180906160304u37f8c702m808ece710359ef9a@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Richard Hughes <hughsient@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       gnome-power-manager-list@gnome.org,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:44 AM, Corentin
Chary<corentin.chary@gmail.com> wrote:
> Ok, so we just need to patch this file :
> http://cgit.freedesktop.org/hal-info/tree/fdi/information/10freedesktop/10-laptop-panel-hardware.fdi

Yes

> But I'm not sure how to do it to make it works on all Eeepc.

Well, really we want to match "classes of eeepc", so matching with
prefix might be a good idea.

Richard.
