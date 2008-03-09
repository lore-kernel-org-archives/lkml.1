Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYCIU3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYCIU3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCIU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:28:51 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:39922 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYCIU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:28:50 -0400
From: Junio C Hamano <junio@pobox.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.4.4
References: <7vr6f31iwj.fsf@gitster.siamese.dyndns.org>
 <7vr6eknpjf.fsf@gitster.siamese.dyndns.org> <47D416C8.1020903@garzik.org>
Date: Sun, 09 Mar 2008 13:28:39 -0700
In-Reply-To: <47D416C8.1020903@garzik.org> (Jeff Garzik's message of "Sun, 09
 Mar 2008 12:56:40 -0400")
Message-ID: <7v1w6jod54.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Junio C Hamano wrote:
>> The latest maintenance release GIT 1.5.4.4 is available at the
>> usual places:
>>
>>   http://www.kernel.org/pub/software/scm/git/
>>
>>   git-1.5.4.4.tar.{gz,bz2}			(tarball)
>>   git-htmldocs-1.5.4.4.tar.{gz,bz2}		(preformatted docs)
>>   git-manpages-1.5.4.4.tar.{gz,bz2}		(preformatted docs)
>>   RPMS/$arch/git-*-1.5.4.4-1.$arch.rpm	(RPM)
>
> Does it address the following issue, present in git-core-1.5.4.1-1.fc8?
>
> http://marc.info/?l=git&m=120423022832530&w=2

I do not think so.

Is it really an issue, or is it just a warning message unread/unfollowed?

I am comparing the last line you quoted from the command output in that
message, which suggests the user to run 'git prune', and your comment on
the next line in that message that says "I regularly run 'git gc'", and
scratching my head.  I cannot tell if you regularly run 'git prune' or not
from it...


