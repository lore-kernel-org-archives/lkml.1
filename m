Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYANToz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYANToz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYANTos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:44:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:33711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYANTor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PMoWlnWhlSFZwMcNx+n41TdMjZqG3Nxk5Q17kzT045mRiJhmvNgV6YiS2H29d18L6NAG2/ujJNpRMExPY3PLPhyXw0HcjNKsLiWV5OC1y1qiO4ePU3JKWghtHauNInfrnu6Qwt1I54OSolrotk3SU1Nk23IywibEgHKzf90JDzA=
Message-ID: <478BBBAA.3090904@gmail.com>
Date: Mon, 14 Jan 2008 20:44:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Daniel Walker <dwalker@mvista.com>, Andy Whitcroft <apw@shadowen.org>,
       Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
References: <47873505.7040008@gmail.com>	 <1200043399.3905.9.camel@gimli.at.home>	 <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com>	 <1200044206.29897.73.camel@imap.mvista.com>	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>	 <20080114171736.GC19327@shadowen.org>	 <1200332116.31521.3.camel@imap.mvista.com>	 <20080114191243.GB25058@shadowen.org> <1200338243.31521.10.camel@imap.mvista.com> <478BB89A.803@s5r6.in-berlin.de>
In-Reply-To: <478BB89A.803@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2008 08:31 PM, Stefan Richter wrote:
> it is with cat.  There you have to type no less than 'cat --help', or at
> least with GNU cat.)

--h (--he --hel --help) suffices due to getopt_long gnu implementation
