Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbYESW0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbYESW0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760710AbYESWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:25:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46287 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbYESWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZemFD8i65OpUlE69oGmU5dthkPO5k6pqSHerpp7W9evG4656Y9vAdshbN3XcJHHMI+FF+GqioC2bxUPhMt3cBQHTVRzCOTyTWblikBWeVY0Mejv+5rjBgl08x/MwEpygDKZSp3YnWOH7fTkjC+3gVDiebi5NSYRYTjevM1T1erA=
Message-ID: <b6a2187b0805191525w52fb1712x7f46556d28ef21c8@mail.gmail.com>
Date: Tue, 20 May 2008 06:25:43 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       "Shaohua Li" <shaohua.li@intel.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <alpine.LFD.1.10.0805190822440.32253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
	 <alpine.LFD.1.10.0805190822440.32253@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>        git bisect visualize
>
> and pick any commit that is active (avoiding the endpoints) and looks like
> a good candidate to test. Then do "git reset --hard <that-commit>" and try

Trying that now.

Thanks,
Jeff.
