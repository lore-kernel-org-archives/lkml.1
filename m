Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYDNUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYDNUqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYDNUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:46:12 -0400
Received: from web52508.mail.re2.yahoo.com ([206.190.48.191]:32163 "HELO
	web52508.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752271AbYDNUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:46:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YWR82UKYjfb5N0D2jTy2S6LxZrKC5ClVEzMp97oqtExVNOPXKdcuS6witDq9ZJ1zV++l8Z3PQ+uVYqR8LoJD2CwhkJIScacERrQvepaJI9B2a/ZKeSTrmzXkVpmCDNrluUEeJir/4G3i8geetAem7N1nDdV6GQpBUzZKugGLPBw=;
X-YMail-OSG: IXKKLP0VM1lQa0.v2SYKklBqWxTK31Kav_yF_OAUE1k7cUs9TaJ791QFV4Qrjj6wT5qqARkVmn05ZGuec0hG0c1uMBEep5KAd3SPB8RKCfju6QsrOJ0-
Date: Mon, 14 Apr 2008 13:46:10 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4803AD83.4030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <436294.91693.qm@web52508.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Snook <csnook@redhat.com> wrote:

> Marc Perkel wrote:
> > My best guess at this time is that the drift of
> this
> > computer using the quad core is so great that the
> ntpd
> > can't get in sync. Is there any way to make ntpd
> more
> > agressive by setting something in ntp.conf?
> 
> ntp can correct for 500 ppm drift, which equates to
> 1.8 seconds per hour. 
> Beyond that you need to run ntpdate or ntpd -gq from
> cron to correct it.
> 
> -- Chris
> 

OK - but do I have bad hardware or is there a problem
with the kernel?



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
