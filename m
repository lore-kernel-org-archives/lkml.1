Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZKJQWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZKJQWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZKJQWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:22:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63702 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZKJQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FxvhQgAWhJrYA6hFWUXqOmkx9syIqQGyTDxrcVAUDhuNw8ONtXOD1wPvE/hxOpzJvO
         g/ScRLMpBSxDqxQHCzRBvk8GboEtmw0DC5p9Ct9GwMg0joumomI6YYP9qHCNVRSZ46TH
         r5PfJ/DzpeS75xNJMlsBVJ6y1wZEV+wN2mcQ8=
Date: Tue, 10 Nov 2009 19:22:35 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, zaurus-devel@www.linuxtogo.org
Subject: Re: [RFC PATCH 1/2] power: implement platform battery driver
Message-ID: <20091110162235.GA22476@home.pavel.comp>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com> <1257820673-30801-2-git-send-email-fercerpav@gmail.com> <20091110132129.GB26144@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110132129.GB26144@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 10, 2009 at 02:21:29PM +0100, Pavel Machek wrote:
> > + * Use consistent with the GNU GPL is permitted, provided that this
> > + * copyright notice is preserved in its entirety in all copies and derived
> > + * works.
> 
> gpl with additional restrictions? can we get standard gplv2 header?

Yep, sure. Sorry, that's a dumb copy/paste from the old Balaji driver.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
