Return-Path: <linux-kernel-owner+w=401wt.eu-S1764740AbYEFPiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764740AbYEFPiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbYEFPiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:38:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:33323 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYEFPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ew0rattuQ2YKxz5eZbiZ6G7OiKXa7JJQnw/oq1d3pa4ffhuGU/cavUiu4byMsFjWSf1RtnP9xoKREvJUq1LdmoDMlRTNC6HIE6E9Z1domjnQrIIYuJozuuY8Y13K4HGgWIx+4OPNQiWIF+11EIizHG4T5YbgruiSMSrkaZOe0qY=
Message-ID: <8bd0f97a0805060837x530bc130vd5b15392d5549c3d@mail.gmail.com>
Date: Tue, 6 May 2008 11:37:58 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: monstr@seznam.cz
Subject: Re: LTP for no MMU systems
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <48207888.3070107@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48206ECF.9090005@seznam.cz>
	 <8bd0f97a0805060749j28cb6fe6wfbdf0d3948d2f417@mail.gmail.com>
	 <48207888.3070107@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 11:26 AM, Michal Simek <monstr@seznam.cz> wrote:
>  where is your repo with ltp and tests results?

we just pull down the LTP releases and any fixes/changes that need to
be made, i commit back upstream.  as for results, i'll have to ask our
testers.
-mike
