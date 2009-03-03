Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZCCP3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZCCP3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbZCCP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:28:55 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58264 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbZCCP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:28:54 -0500
Message-ID: <49AD4C74.1060704@s5r6.in-berlin.de>
Date: Tue, 03 Mar 2009 16:27:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>	 <49ACC6B0.409@garzik.org>	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>	 <20090303072637.GB4440@kroah.com> <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
In-Reply-To: <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 11:26 PM, Greg KH <greg@kroah.com> wrote:
>> Who are these "people" that you are trying to convince?
> 
> OK small silly example is convincing distributions it may be a good
> idea to carry linux-next kernel packages as options to users to
> hopefully down the road reduce the delta between what they carry and
> what is actually upstream.

Distros would do their users a bigger favour if they didn't just dump a
random new driver into their kernel package, but if they instead (or in
addition) support the process to get new drivers into the mainline.

It's a favour to their users because maintenance in mainline generally
means better quality.  (Less drivers which break suspend/resume etc. pp.).

It's also a favour to themselves because the maintenance of their kernel
as a whole will cost less if it is a stabilized derivative of the
mainline instead of an unstable (and merely potential) predecessor of
the mainline.
-- 
Stefan Richter
-=====-==--= --== ---==
http://arcgraph.de/sr/
