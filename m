Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbZFJTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbZFJTtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbZFJTtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:49:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59240 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760346AbZFJTs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:48:59 -0400
Date: Wed, 10 Jun 2009 20:48:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, swetland@google.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090610194852.GA28787@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610103131.GB13885@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 12:31:31PM +0200, Pavel Machek wrote:
> Is there patch for Dream support for 2.6.30 somewhere? The best I
> could find is linux-msm tree, which is ... quite a big diff against
> 2.6.24:

In short not as far as I know, and I'm very disappointed with the state
of affairs with google.

Basically, the situation surrounding msm can be described as severely
wanting - bear in mind that it's been over a year since we last heard
anything from the msm guys as far as code submissions go.

Personally, I think we should delete the entire codeset which was
submitted into mainline - it's next to useless and all the time that
folk sit on their hands not maintaining it, it's just not worth having
it anywhere near mainline.
