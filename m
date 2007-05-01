Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbXEAWsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbXEAWsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXEAWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:48:04 -0400
Received: from web54405.mail.yahoo.com ([206.190.49.135]:24874 "HELO
	web54405.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754728AbXEAWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:48:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 18:48:02 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sajXkDZl3fXFHg8cIbdgOjFMASgaZBZpFn1kwvNC5zTSFs4+aRfh2TQO77PAtrSsEcDl1waFs6XbDe0Y/FXSFVXGkUaFuJseiA3a2FY/ah4qoNsRZ/7uqpdYVWQIyy2ZrWylqY1rwyP4xw9WL3nji1hpR15js5QMG0Xwj5oBvo0=;
X-YMail-OSG: _RA_idoVM1m0E0ytSdYHP_HUcCPhBMAu8mFOYansDiSi.FDBlCP3lm499JgXLnYomQdu0L6Z6C.Eqf8lETKy_tKdI0v_JELmnTU1eWfJm1y0Xi2L1jk7DbwCyg6vXxg8efC.SXi3KMqFwUcFKPL.YMArrA--
Date: Tue, 1 May 2007 15:41:19 -0700 (PDT)
From: Vlad <vladc6@yahoo.com>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <741290.4122.qm@web54405.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I'm rewriting the i386 setup code in C, instead of assembly,
> and before I spend a very large amount of time translating
> all the various card-specific probes, I want to ask the
> following question...
>
> Does *anyone* care about these anymore?

Yes, booting Linux on old i386/i486 hardware is still very useful for
forensic purposes and recovering important data. I've personally had
to do this many times, and I'm sure others have as well.

Booting is such a critical process that a user would be completely
lost as to why it fails, especially if they can't see any output on
the screen. I think it would be a shame to prevent Linux from running
on these machines.

Vlad

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
