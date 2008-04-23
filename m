Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYDWFD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYDWFD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYDWFDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:03:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49070 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYDWFDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aF7yPwXuKkmA3JqgI5ZFcBW+ky8XESfo3kyYQb77xfNjs18Po5NRvmQA77LXLV8DBMym+iWRlQ4IVO8Y0O8cAv9KoNo7W7O+aw6jVCp9j4X8ScIonaPO1opYaA6anGi2rWToqIdPpeGQfzmnHYQj/ndArzr/kRs33eQUUoUXW3o=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: x86: 4kstacks default
Date: Wed, 23 Apr 2008 07:03:11 +0200
User-Agent: KMail/1.8.2
Cc: Daniel Hazelton <dhazelton@enter.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804201144.33308.dhazelton@enter.net> <1208888454.10279.7.camel@localhost>
In-Reply-To: <1208888454.10279.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230703.11816.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 20:20, Romano Giannetti wrote:
> On Sun, 2008-04-20 at 11:44 -0400, Daniel Hazelton wrote:
> > Since the second-most-common reason for stack overages is ndiswrapper... Well, 
> > with there being so much more hardware now supported directly by the linux 
> > kernel... 
> 
> How would I like you being right... Atheros AR5008, AR5414 PHY, "not yet
> here". It's almost one year now since I bought this laptop, and till now
> it's the cable or ndiswrapper. But yes, it's going better. For my first
> wifi laptop I waited two and a half years, now it seems that in a bit
> more than one there will be an open source driver...
> 
> I know all the trouble ndiswrapper signify. But I see also that people
> around me with a laptop and linux use more ndiswrapper than a real
> driver, so... be gentle with it. 

Nobody knows how much potential development is not done because
"you can make your wifi work with ndiswrapper".
--
vda
