Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZFPIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZFPIrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZFPIrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:47:06 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:53321 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZFPIrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:47:05 -0400
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 04:47:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X+Mjc9XqJaMv6afjKW/ZnpZiGx7mv7UMZtDoCVLKyd1RtCApiMpnJ8fyJsjvTkGhkI
         dj8XwZXf3EtE20SPQrtFVw4a6RfkuBukfpK7MFc2xRe47EBtIMTpgdePNcQMcRoZqeFi
         ay5oYRbGd00O8Wz5sgfLn9lyX/Kc93l+9u180=
MIME-Version: 1.0
In-Reply-To: <4A375914.5050800@tuffmail.co.uk>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
	 <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
	 <4A375914.5050800@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 09:47:06 +0100
Message-ID: <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Richard Hughes <hughsient@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: gnome-power-manager-list@gnome.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Corentin Chary <corentin.chary@gmail.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 9:34 AM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> The driver doesn't.  As far as we know, none of them do.  Firmware does.

In that case there's a "laptop_panel.brightness_in_hardware" hal quirk
that turns off all the fancy stuff, and makes the GUI DTRT without
guessing.

Richard.
