Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0CJJNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:13:34 -0500
Received: from web7607.mail.in.yahoo.com ([202.86.4.26]:20130 "HELO
	web7607.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751142Ab0CJJNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:13:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RTrUcBeZLupMNXq/Zq9Cz+GSR+GqOIV3OgzefpU7iF0M62keclDXbxfWgR+HDsH3H5Tr/Mm01iNIv3XkD73yGcorhykgS8IQ+xKQ5eAtOsf7IcF3V+8KsEzsLqBuWmgGzQnVC6elwV32a3d0kRSP+K0/lZgV7Od9jVsZP0dH9Rs=;
Message-ID: <983251.67335.qm@web7607.mail.in.yahoo.com>
X-YMail-OSG: dqnT3OEVM1nKbit6gG3J121mZaMaC.iJ_1ZnGGv7teI7gJk
 cvyDovrRK19drZGiB..Wxj83K_4Hd.VwBoHWZMHGidugH1bIs88UKIYD0GSh
 ZiAjvM2VhokqbzjDVWVx4LBv82JDrZxn8BYLdHQyVDIF6M1yPPL8MadZ4UFs
 03rZqIlDy1jEiTc5_iXpgz_WsvpddLpVbWJVnXimlt0FkHATfheUz84nQ6hv
 sXL0dNM26cZED.ojQ4se22ulLqqHYXRzZpwKUfwgyGqj624Q8NUfAL8t3cm7
 Qgdg1LoFpmjQfFvh80A718LQQxz7VjeDf1AbREbc-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Wed, 10 Mar 2010 14:43:28 +0530 (IST)
From: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B975CB4.4000804@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,

I am not writing to network mounted disk. This is locally mounted and filesystem is ext3.

With best regards,
 
Yours sincerely,
Srinivas Nayak
 
My Home page: http://www.mathmeth.com/sn/
My Blog: http://srinivas-nayak.blogspot.com


--- On Wed, 10/3/10, David Newall <davidn@davidnewall.com> wrote:

> From: David Newall <davidn@davidnewall.com>
> Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
> To: "Srinivas Nayak" <sinu_nayak2001@yahoo.co.in>
> Cc: linux-kernel@vger.kernel.org
> Date: Wednesday, 10 March, 2010, 2:17 PM
> Dear Srinivas Nayak,
> 
> I don't suppose you're writing to a network mounted disk,
> with the network device's clock about half a second behind
> your test machine?  Otherwise -- and I'm just guessing
> here, and will leave it to you to UTSL -- this could be
> explained by use of two different algorithms for converting
> a higher-resolution time source to the one-second
> resolution.  A truncation algorithm versus a rounding
> algorithm could produce the result you demonstrate.
> 
> Regards,
> 
> David
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
