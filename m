Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbXEQVVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbXEQVVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXEQVVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:21:48 -0400
Received: from smtp801.mail.ird.yahoo.com ([217.146.188.61]:34511 "HELO
	smtp801.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755041AbXEQVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:21:47 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 17:21:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xj/PAerqpxqwoctiLGMhjr/vsMzJDPuAzOFmN7XeNaKjfiKmvlC+q4Z45MvgyJNlu2jCWd7T0Qwp8DvSJHsz4hC0iea56HH70omfzRRhxmVE6OSt45hnoLTVovas+ldMFxg7hkQy6nldb6OsrkJQtdFSjTCoxrsTzTHK9jGj5yI=  ;
X-YMail-OSG: hGp2pu4VM1kUvoSj.YyiTJgvRrNuINXY3.jCOcnCtIXSEJujZGKU4W2ZZsJcseQZWKd8eMkilUtB9O6Y.jhvUcg8YZBjv._sUTOnLf6ti9z6TVpj1MYu5UGoeRs-
Message-ID: <464CC5D9.8070301@btinternet.com>
Date: Thu, 17 May 2007 22:15:05 +0100
From: Francis Russell <FrancisRussell@btinternet.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: pata_via appears to incorrectly detects 40-pin cable
References: <990930.5739.qm@web86408.mail.ird.yahoo.com> <464CB820.6050708@rootdir.de>
In-Reply-To: <464CB820.6050708@rootdir.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claas Langbehn wrote:
>
> This is bug 8142. Please see 
> http://bugzilla.kernel.org/show_bug.cgi?id=8142

Apologies if this wasn't clear from context. The drive (Hitachi 
TravelStar 7K100) is IDE not SATA so differs from this bug in the way 
that the cable check should be relevant.

Francis
