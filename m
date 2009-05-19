Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZESOhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZESOhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZESOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:36:55 -0400
Received: from web23608.mail.ird.yahoo.com ([87.248.115.51]:37028 "HELO
	web23608.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753415AbZESOgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:36:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=03WwTE+uVUi4N0FH4l7qFCX8UV3zh0CtPr1c2L0nNInbeRAlo1jWCX+saP7a6rbQophUQ7LMxM5x32O0huYVpa9fpykvWeeGWkjYHS7SUKmWjBaeeZt75OtKbXhfGw784JKCCcs04WgPeVpxTZju3SpJZx5lvWtccNWA0ytyhUY=;
Message-ID: <607293.42795.qm@web23608.mail.ird.yahoo.com>
X-YMail-OSG: dgWbJucVM1lJR65Z.ZqdSVsleygWCVkaUm8kqhqbYoATi.59CG1_eaHj.XCT0TVotwUyVROdWqn_LPItDv.Rx1NIQO6daRlfX53BvEK5YCKDbQsMgIUITl_61lCYmdrn3j4DLOmouPxbwVsJHB2LwX1WtalE0VBeO6bU2M2NMulqhuyeVdS7xSqLj.wMSs99mMSeO1m.Tybq7H2HQfOH4sSORI_mB2GM7FtvtOeIEnaywH.RWuH_yDoKyrTmRLMYnU_FCeJT.WdPGhBdH1s10VZQlnvXwFMWPsz5tg6rjGPALOyZCg--
X-Mailer: YahooMailClassic/5.2.20 YahooMailWebService/0.7.289.10
Date: Tue, 19 May 2009 14:36:54 +0000 (GMT)
From: Andrea <andrea256it@yahoo.it>
Subject: Re: super root shell/mode/api
To: 7eggert@gmx.de
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If there is a malware with root privileges, this would be of no use. You are
> 0wned.
> 
> If there is a malware with user privileges, stopping these processes will
> be enough.
> 
> So why bother?

That's exactly the problem a remote attacker or virus
can gain root and you are completely powerless. You want
to save data? The attacker just logs you out before you
can run any command. You can't even backup or save
data! You are owned. Yes.

With this super shell/mode/menu in less then one second, you stop
everything - a global SIGSTP - and gain control over your machine!

You can save all memory, e.g. for controlling what happened 
or data recovery, sigstop without hurry all processes that seems
a problem and so on.

Then when you have saved everything, made a backup of the hdd,
stopped the processes with viruses or too much memory you can
unfreeze the system - a global SIGCONT and it was like stopping
the time. Attackers, viruses, OOM processes are stopped in less
then one second. You can go back to the system whenever you
want. You the console user finally have power. 

The value of such a tool is only evident once you had it.

I can give you a lot of other reasons, but I must work now,
maybe in some days.

Regards.

Andrea Gedda



      
