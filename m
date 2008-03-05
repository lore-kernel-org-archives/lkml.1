Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYCEVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYCEVD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYCEVDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:03:49 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:22202 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755211AbYCEVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:03:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1HiK62FJP4/WaZ4KNtmndpfVQB8HQcRu0ibWpGh5wAx9srMY8j8PiD5PlrSlMletYeQhito/J/lXp7bM3Qni2mAvwrJopobR4fwE+/Uu8Cqc0iCEfAcRpMTr+sYCY+EOM/FbH+qWGeZcexCW85NgMyod5yYmAhtCCbbpvcYriFs=  ;
X-YMail-OSG: W9hzm.QVM1nwYhVYYQsiFjkEj8r.FNKJ0Or9dP5GHGynIvN_h.bNaZAVUh5TPTpYKr4Lu6zy_Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: ehci-hcd affects hda speed
Date: Wed, 5 Mar 2008 13:03:45 -0800
User-Agent: KMail/1.9.6
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47CEC816.6000808@keyaccess.nl> <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com>
In-Reply-To: <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051303.46275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Alessandro Suardi wrote:
> I reported this problem well over an year ago, and it was never fixed.

Yeah, nobody who can debug the problem has hardware that ill-behaved.

It'd be great if someone could chase this down.

- Dave
