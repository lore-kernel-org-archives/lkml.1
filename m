Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYKIUhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYKIUhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYKIUhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:37:40 -0500
Received: from relay3-v.mail.gandi.net ([217.70.178.77]:37546 "EHLO
	relay3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbYKIUhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:37:40 -0500
X-Greylist: delayed 2823 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2008 15:37:40 EST
Date: Sun, 9 Nov 2008 21:37:37 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081109203737.GA2056@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20081109195033.GA1335@mobydick> <200811092059.31178.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811092059.31178.rjw@sisk.pl>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 08:59:30PM +0100, Rafael J. Wysocki wrote:
> Please check if that's http://bugzilla.kernel.org/show_bug.cgi?id=11989 and
> if that's the case, please add a "me too" to the bug entry.

Thanks for the quick reply, sadly I don't have CONFIG_STOP_MACHINE
defined so that's not it...
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
