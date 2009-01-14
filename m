Return-Path: <linux-kernel-owner+w=401wt.eu-S1761105AbZANJQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105AbZANJQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZANJQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:16:32 -0500
Received: from web53304.mail.re2.yahoo.com ([206.190.49.94]:31631 "HELO
	web53304.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752805AbZANJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:16:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=ZeJYaRGba1ieu9qgV8pIwyNy7nJP1C+S6C/29wKeFcrJ+i4jCuLcN34AFXsa9Ob3yhQWCqxwg7KJ0TQ/pUgn8zeTi+YWbIGr9jsBGirnvERwXoaPyqktJA745iSBvQSrVlCgc0JMveGh4+/jGjJkvk7eSdA9TDCB4quvNwm1+Ak=;
X-YMail-OSG: VcX8J2kVM1k6PIg6YIVyiIAYoyp9XogXTaw6bkI5JDHxz4zQtfQZVsbZQ.AFtEJt6nDL0jeFg9OqqJqR6MuLzqQLJXFt6ucqJ_8VD59y9TzdHPyDWf5ksVAP0nSScCLAuVYfFR6RN9A9TZfbAEqCBO9F9skgBv4U4x.2fZcNOjhFsGb43yE0PdMur851armR_n.3xvOKLKuos4Iu2BNXfDdyQQ--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 14 Jan 2009 01:09:49 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <nHCfeC0YLrE.A.AOC.uafaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <620527.41204.qm@web53304.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Sun, 1/11/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> The following bug entry is on the current list of known
> regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it
> still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	:
> http://bugzilla.kernel.org/show_bug.cgi?id=12337
> Subject		: ~100 extra wakeups reported by powertop
> Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
> Date		: 2008-12-31 12:25 (12 days old)

I was waiting for 2.6.28.1 to come out and test it, but since it's not yet out just to say that yes, the problem is still there.

Alberto.


      
