Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYFMFpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYFMFpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 01:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYFMFpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 01:45:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:19156 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYFMFpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 01:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tJjdukgx09rPvBAx8ItJqxJRcPmpvkczHrppop1xArO443Win7NIF0URg4V31nWzTN
         bPczYm5kpQHDGcZJ7zVFH9lOvXXp3EDaujuUVxldsfASvvq0i7YNH0myqx9itohvOy1r
         Y5dnOeYH0y10ixOqhUvmCZhKXp4OhJpMJi3qE=
Message-ID: <e2e108260806122245xb2fdd36teb2f265317370875@mail.gmail.com>
Date: Fri, 13 Jun 2008 07:45:22 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Mahmoud Hanafi" <mhanafi@csc.com>
Subject: Re: Tracking all signals how to
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <OF63113826.C91E01A9-ON85257466.0076BE5C-85257466.0076CEB5@csc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF63113826.C91E01A9-ON85257466.0076BE5C-85257466.0076CEB5@csc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:37 PM, Mahmoud Hanafi <mhanafi@csc.com> wrote:
> We have random nodes experience killing of most daemons( syslog, ssh,
> cron, etc). All these daemons report getting a sigkill or sigterm.
>
> My question.... Is there a way to log all signals and the originator
> pid/proc name.

Did you already have a look in the kernel messages to make sure it's
not an OOM problem ? I do not know of any Linux software that sends
random signals to random processes.

Bart.
