Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXJDCJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXJDCJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXJDCJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:09:31 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64460 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbXJDCJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:09:30 -0400
Date: Wed, 03 Oct 2007 20:08:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Point of gpl-only modules (flame)
In-reply-to: <fa.uOYpsaQzzWwjjKspWNuGWwuESHM@ifi.uio.no>
To: Jimmy <lists@dusted.dk>
Cc: linux-kernel@vger.kernel.org
Message-id: <47044B11.4070500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.uOYpsaQzzWwjjKspWNuGWwuESHM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jimmy wrote:
> I know I'll be getting hell for this, I must be a masochist.
> 
> Anyway, I've been trying to figure out what purpose the gpl-only code 
> serves.
> What good comes out of disabling people from probing modules that do not 
> have a gpl-compatible license?

Who is disabling anything?

> Of cause, I would love to see more hardware manufactures release either 
> full specs, or GPL'd drivers, and I'm sure it will happen, in time.
> But until then, why are people wasting time writing code to inhibit 
> those who do not agree with them on licensing?
> 
> It seems pretty childish to try and force some license on people, 
> imagine trying to install firefox on Windows Vista, an error-dialog box 
> appears:
> "This application has been denied access to the Windows API as its 
> license are compatible with the Microsoft Philosophy" ?
> 
> Now, i don't want to waste clock cycles on executing code that serves no 
> purpose but restraining me from using my $1500 gfx card as intended, so 
> will me removing that crap from the source result in somebody trying to 
> obfuscate it to a point where neither of us know what is what?
> 
> Also, how about a list of PROS, explain to me whats so cool about it?

The kernel gets marked as tainted when you load proprietary modules 
because with no source code available there is no way to determine what 
kind of badness the code may have done to break the kernel. Bug reports 
from tainted kernels are generally given fairly little weight.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

