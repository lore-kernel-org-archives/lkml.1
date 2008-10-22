Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYJVHWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYJVHWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVHVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:21:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:26151 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYJVHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=MLuLEtNkg+ff08K4w97gknQ8RJen1+sAv5SP6s4CrQYN4Qm6CT/e0yD9ILPBlbBmVe
         RL/k0rP0q0fFh9KlDS5sPA2/MexZbLEcdEB8xQRX9NvK2PbwtuIemN3sNEAOPmNgfnT5
         571Q0ON6PizeGFIIXnP8cHySWDtk54MpVyhCI=
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, akpm@linux-foundation.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed	read-only	filesystem
References: <E1KqrTW-0001x8-3h@dylan>
	<1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
	<48FD2C74.2070608@lougher.demon.co.uk>
	<1224605348.31157.67.camel@moss-terrapins.epoch.ncsc.mil>
	<48FE68E9.2020401@lougher.demon.co.uk>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 22 Oct 2008 09:21:44 +0200
In-Reply-To: <48FE68E9.2020401@lougher.demon.co.uk> (Phillip Lougher's message of "Wed\, 22 Oct 2008 00\:42\:33 +0100")
Message-ID: <87r669nlh3.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:

Hi,

 Phillip> Yeah, Git is much better than CVS, however, I've got nowhere
 Phillip> to host a public Git repository.  If someone were to offer
 Phillip> hosting I'd be only too happy to move over to Git.

You could apply for a kernel.org account:

http://kernel.org/faq/#account

-- 
Bye, Peter Korsgaard
