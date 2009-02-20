Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZBTC42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZBTC42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZBTC4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:56:19 -0500
Received: from web33505.mail.mud.yahoo.com ([68.142.206.154]:32215 "HELO
	web33505.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751123AbZBTC4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:56:18 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 21:56:18 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=wE8CAEuEUAEN5+w4G6d1lpIgJXdbymyYNVbwWcDCsIcY44xkMnJnH4kIhXV0gSuZyRl/m2rfMrvLtfxLH4Qjt61f3tJu4lqWdNvQtIIlq8WtDSxlTP5gfvh+o4PXdkJgeOQrSffpbvMQzAAq3o/DJQ4NECnwiWRyZnerQZCWQP4=;
X-YMail-OSG: F0YiZyEVM1msl7q064I4fJyyBXdmPs_W.hTgjjQF2BE1I08FelduAgd_o7WkcoL9QM8arGu67TtclSywSdmy8Bd0grDyXkBOyNuihhdWE0.BoTsuvlib._tUc4nerPgCVwOCbuknpAJHERkrTZSHlUqeeXdKSQJfpd6DRi7cfxqUJFOsbGlvHUv2wBeDcRraLdRK8w1c9yaMzI0gKB124O.Q4n8j1IkhX79veEz.9UG6.w--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 18:56:17 -0800 (PST)
From: Nick Levinson <nick_levinson@yahoo.com>
Subject: suggest make standard list of CR/LF prefs that apps can read for portability
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <536945.50089.qm@web33505.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Battling between Windows Notepad, Linux gedit, and OpenOffice.org conventions on how paragraphs are separated in text files using CR and LF characters, I'd like the ability to set a preference the same way I'd set one for currency or daylight savings time. A user wouldn't have to pick, but if a user does all applications could agree with it.

It would be up to each application designer to comply or not. Noncompliant apps should not break.

Among the options: whatever the application normally sets if I have no preference, CR alone, LF alone, CR+LF, and LF+CR. It might be nice if among the options was one to simply choose that in a well-known stable application, such as one of those above. Each user could have their own pref. And an app could override it.

Thanx.

-- 
Nick


      
