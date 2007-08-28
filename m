Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXH1XGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXH1XGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXH1XGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:06:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:46081 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXH1XGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bhA4aBKHvkzLlKJqBCcemk71J7WZ42WmDbSv2tsxBi3p+hJCGZYkCrUm3++akQ2/zV5OoEZ7G6CzpVkZJl0vhgRMBEiQ7arRJtvQp6mGld2wQE5XgVthP9caK45rz5V/wYPl9sqrWzaoMWlaFMb8SZ0dEyfvOts3zocRLnDJekk=
Message-ID: <6bffcb0e0708281605x3157c740v34aaaae54f9517a0@mail.gmail.com>
Date: Wed, 29 Aug 2007 01:05:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [3/4] 2.6.23-rc3: known regressions v3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Thomas Meyer" <thomas@m3y3r.de>
In-Reply-To: <20070824104601.04a6b529@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF0DEF.5040107@googlemail.com> <46CF1796.1020004@googlemail.com>
	 <20070824104601.04a6b529@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 24/08/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> O
> > Subject         : New wake ups from sky2
> > References      : http://lkml.org/lkml/2007/7/20/386
> > Last known good : ?
> > Submitter       : Thomas Meyer <thomas@m3y3r.de>
> > Caused-By       : Stephen Hemminger <shemminger@osdl.org>
> >                   commit eb35cf60e462491249166182e3e755d3d5d91a28
> > Handled-By      : Stephen Hemminger <shemminger@osdl.org>
> > Status          : unknown
> >
> >
>
> Fix posted to netdev (sky2 1.17 series), but Jeff hasn't
> applied it.
>

commit 32c2c30085324aef9699934295281cca0161ef7e I guess

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
