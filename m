Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZIGP7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZIGP7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZIGP7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:59:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62811 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZIGP67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BuZPsfCHFVEq6rZQtW4gqFMBiJITBBU7ryREIKgIIGh8pYOoF5wAcbG5V+3cQYfGqm
         LyHF4/fIDFqM2Ctpf4DkF5SDinW7urrDPXOIWrZBBIhAJyMrtGXB0mENK7HhAuZjEywr
         oNjWsbtKfdhGs9fY1CwvnYW5EntZd0Djqj8aw=
From: Diego Calleja <diegocg@gmail.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 18:00:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6; KDE/4.3.1; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Markus Tornqvist <mjt@nysv.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       kernel@kolivas.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de
References: <20090907121613.GA32097@elte.hu> <20090907074507.7f00a3ec@infradead.org> <1252337069.31087.17.camel@skunk>
In-Reply-To: <1252337069.31087.17.camel@skunk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909071800.49749.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes 07 Septiembre 2009 17:24:29 Xavier Bestel escribió:
> Except on your typical smartphone, which will run linux and probably
> vastly outnumber the number of "traditional" linux desktops.

Smartphones will probably start using ARM dualcore cpus the next year,
the embedded land is no SMP-free.
