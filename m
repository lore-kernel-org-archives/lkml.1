Return-Path: <linux-kernel-owner+w=401wt.eu-S965150AbXBVAeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150AbXBVAeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965135AbXBVAeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:34:17 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:45424 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965138AbXBVAeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:34:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KiZfL8hSCGxJh1RsPVOKOgvW3KWpF5FuG7v7LVARiP6AXGfbetfYeD/WH3Q5vlKtOuzO8pSypKnP4bVWbP3zon2Z8B21bhxlEjiZ7RYNaMdKvWFs1qseXeakXD0qPOexblMWc5Cy2GhUkoi/i7FYAbPk8dK7lqwKuvANdp0bU2Y=
Message-ID: <f2b55d220702211634s77d23ddem8ee6523ff6020d98@mail.gmail.com>
Date: Wed, 21 Feb 2007 16:34:15 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070221230503.GA28156@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070219134539.GA27370@flint.arm.linux.org.uk>
	 <20070219143520.GB27370@flint.arm.linux.org.uk>
	 <20070220144814.GJ566@slug>
	 <20070219150508.GD27370@flint.arm.linux.org.uk>
	 <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
	 <20070219212347.GA4258@flint.arm.linux.org.uk>
	 <45DC537B.6020108@inov.pt>
	 <20070221230503.GA28156@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Are you using an unpatched gcc 4.1.1?  Its optimizer did nasty things
to us, at least on an ARM target ...
